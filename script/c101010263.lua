--created & coded by Lyris
--超竜星ドゥニンル
function c101010263.initial_effect(c)
--attribute(field)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_ATTRIBUTE)
	e0:SetCondition(function(e) local c=e:GetHandler() return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) end)
	e0:SetValue(0x3f)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101010263,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c101010263.condition)
	e1:SetTarget(c101010263.target)
	e1:SetOperation(c101010263.operation)
	c:RegisterEffect(e1)
	--synchro effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetCondition(c101010263.sccon)
	e2:SetTarget(c101010263.sctg)
	e2:SetOperation(c101010263.scop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(function(e,te) return te:GetOwnerPlayer()~=e:GetOwnerPlayer() end)
	c:RegisterEffect(e4)
	--pre-tuning
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_PRE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetLabel(0)
	e3:SetCondition(c101010263.tcon)
	e3:SetOperation(c101010263.tnop)
	c:RegisterEffect(e3)
end
function c101010263.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp
end
function c101010263.filter(c,e,tp)
	return c:IsSetCard(0x9e) and not c:IsCode(101010263) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010263.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101010263.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101010263.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101010263.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
function c101010263.sccon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return false end
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_BATTLE or ph==PHASE_MAIN2
end
function c101010263.mfilter(c)
	return c:IsSetCard(0x9e)
end
function c101010263.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c101010263.mfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101010263.scop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c101010263.mfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end
function c101010263.tcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c101010263.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)==0 or not c:IsLocation(LOCATION_GRAVE) then return end
	--[[local at=0x6f
	local mg=c:GetReasonCard():GetMaterial()
	mg:RemoveCard(c)
	local tc=mg:GetFirst()
	while tc do
		at=bit.bxor(at,tc:GetAttribute())
		tc=mg:GetNext()
	end]]
	Duel.Hint(HINT_SELECTMSG,tp,562)
	local at=Duel.AnnounceAttribute(tp,1,at)
	rc:SetHint(CHINT_ATTRIBUTE,rc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetValue(at)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetLabel(at)
	e3:SetValue(c101010263.efilter)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e3)
end
function c101010263.efilter(e,te)
	local tc=te:GetOwner()
	return te:IsActiveType(TYPE_MONSTER) and bit.band(tc:GetAttribute(),e:GetLabel())~=0 and tc~=e:GetOwner()
end
