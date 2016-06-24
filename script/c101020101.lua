--Aggecko Tettitory
local id,ref=GIR()
function ref.start(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(ref.con)
	e2:SetTarget(ref.filter)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(ref.actcon)
	e3:SetOperation(ref.atkop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetCountLimit(1)
	e4:SetCondition(ref.spcon)
	e4:SetTarget(ref.sptg)
	e4:SetOperation(ref.spop)
	c:RegisterEffect(e4)
--	--spsummon
--	local e4=Effect.CreateEffect(c)
--	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
--	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
--	e4:SetRange(LOCATION_SZONE)
--	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
--	e4:SetCountLimit(1)
--	e4:SetCondition(ref.spcon)
--	e4:SetTarget(ref.sptg)
--	e4:SetOperation(ref.spop)
--	c:RegisterEffect(e4)
end
function ref.actcon(e)
	local bc=Duel.GetAttacker()
	return bc:IsControler(e:GetHandler():GetControler()) and bc:IsSetCard(0x6d6)
end
function ref.atkop(e,tp,eg,ep,ev,re,r,rp)
	--actlimit
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(ref.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,0xff,nil,TYPE_MONSTER+TYPE_TRAP)
	local ex=g:Filter(Card.IsImmuneToEffect,nil,e)
	g:Sub(ex)
	local tc=g:GetFirst()
	while tc do
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_CANNOT_TRIGGER)
		e0:SetReset(RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e0)
		tc=g:GetNext()
	end
end
function ref.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_TRAP)
end
function ref.con(e)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return tp==e:GetHandlerPlayer() and (ph==PHASE_BATTLE or ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
end
function ref.filter(e,c)
	return c:IsSetCard(0x6d6) and c:IsFaceup()
end
--function ref.spfilter(c)
--	return c:GetSummonType()==SUMMON_TYPE_SPECIAL and c:IsSetCard(0x6d6) and c:IsPreviousLocation(LOCATION_DECK)
--end
--function ref.spcon(e,tp,eg,ep,ev,re,r,rp)
--	local rc=re:GetHandler()
--	return eg:IsExists(ref.spfilter,1,nil) and rc:IsSetCard(0x6d6) and rc:IsType(TYPE_MONSTER)
--end
--function ref.spfilter2(c,e,tp)
--	return c:IsSetCard(0x6d6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
--end
--function ref.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
--	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
--		and Duel.IsExistingMatchingCard(ref.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
--	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
--end
--function ref.spop(e,tp,eg,ep,ev,re,r,rp)
--	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
--	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
--	local g=Duel.SelectMatchingCard(tp,ref.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
--	local tc=g:GetFirst()
--	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
--		local e1=Effect.CreateEffect(e:GetHandler())
--		e1:SetType(EFFECT_TYPE_SINGLE)
--		e1:SetCode(EFFECT_CANNOT_ATTACK)
--		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
--		tc:RegisterEffect(e1)
--		Duel.SpecialSummonComplete()
--	end
--end
function ref.spfilter(c)
	return c:GetBattleTarget():IsSetCard(0x6d6)
end
function ref.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(ref.spfilter,1,nil)
end
function ref.spfilter2(c,e,tp)
	return c:IsSetCard(0x6d6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(ref.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,ref.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end