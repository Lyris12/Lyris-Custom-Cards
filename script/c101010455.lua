--Starry-Eyes Spatial Dragon (DM)
function c101010455.initial_effect(c)
	local ae1=Effect.CreateEffect(c)
	ae1:SetCategory(CATEGORY_TOGRAVE)
	ae1:SetType(EFFECT_TYPE_IGNITION)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ae1:SetCountLimit(1)
	ae1:SetCost(c101010455.bancon)
	ae1:SetTarget(c101010455.bantg)
	ae1:SetOperation(c101010455.banop)
	c:RegisterEffect(ae1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c101010455.sptcon)
	e1:SetOperation(c101010455.sptop)
	e1:SetValue(0x7150)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetTarget(c101010455.reen)
	c:RegisterEffect(e2)
	if not c101010455.global_check then
		c101010455.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetLabel(500)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010455.chk)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge2:Clone()
		ge3:SetLabel(300)
		Duel.RegisterEffect(ge3,0)
	end
end
c101010455.spatial=true
c101010455.dm=true
c101010455.dm_no_spsummon=true
function c101010455.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,e:GetLabel())
	Duel.CreateToken(1-tp,e:GetLabel())
end
function c101010455.bancon(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()==PHASE_MAIN1 end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
end
function c101010455.atkfilter(c)
	return c:IsType(TYPE_MONSTER) and aux.nzatk(c) and c:IsAbleToGrave()
end
function c101010455.bantg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(1-tp) and c101010455.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010455.atkfilter,tp,0,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101010455.atkfilter,tp,0,LOCATION_REMOVED,1,1,nil)
	local atk=g:GetFirst():GetBaseAttack()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c101010455.banop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c101010455.reen(e,tp,eg,ep,ev,re,r,r,chk)
	local c=e:GetHandler()
	local loc=LOCATION_DECK
	if c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) or c.spatial then loc=loc+LOCATION_HAND end
	local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if chk==0 then return c:IsOnField() and bit.band(c:GetDestination(),loc)~=0 and (tc1==nil or tc2==nil) end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function c101010455.sptfilter1(c,tp,djn,f)
	return c:IsFaceup() and c:GetLevel()>0 and (not f or f(c)) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c101010455.sptfilter2,tp,LOCATION_MZONE,0,1,c,djn,f,c:GetAttribute(),c:GetRace(),c:GetLevel())
end
function c101010455.sptafilter(c,alterf)
	return c:IsFaceup() and alterf(c) and c:IsAbleToRemoveAsCost()
end
function c101010455.sptfilter2(c,djn,f,at,rc,lv)
	return c:IsFaceup() and c:GetAttribute()==at and c:GetRace()==rc
		and c:GetLevel()>0 and (djn==lv or djn==c:GetLevel())
		and (not f or f(c)) and c:IsAbleToRemoveAsCost()
end
function c101010455.sptcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-2 then return end
	return Duel.IsExistingMatchingCard(c101010455.sptfilter1,tp,LOCATION_MZONE,0,1,nil,tp,c:GetRank(),c.material)
end
function c101010455.sptop(e,tp,eg,ep,ev,re,r,rp,c)
	local x=c:GetRank()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local m1=Duel.SelectMatchingCard(tp,c101010455.sptfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,x,c.material)
	local tc=m1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local m2=Duel.SelectMatchingCard(tp,c101010455.sptfilter2,tp,LOCATION_MZONE,0,1,1,tc,x,c.material,tc:GetAttribute(),tc:GetRace(),tc:GetLevel())
	m1:Merge(m2)
	c:SetMaterial(m1)
	Duel.Remove(m1,POS_FACEUP,REASON_MATERIAL+0x400000)
end
