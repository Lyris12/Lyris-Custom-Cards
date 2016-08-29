--Starry-Eyes Spatial Dragon
function c101010429.initial_effect(c)
	--attack banish
	local ae1=Effect.CreateEffect(c)
	ae1:SetCategory(CATEGORY_TOGRAVE)
	ae1:SetType(EFFECT_TYPE_IGNITION)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ae1:SetCountLimit(1)
	ae1:SetCost(c101010429.bancon)
	ae1:SetTarget(c101010429.bantg)
	ae1:SetOperation(c101010429.banop)
	c:RegisterEffect(ae1)
	--special summon (Do Not Remove)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c101010429.spcon)
	e1:SetOperation(c101010429.spop)
	e1:SetValue(SUMMON_TYPE_XYZ+0x7150)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(function(e,se,ep,st) return bit.band(st,SUMMON_TYPE_XYZ+0x7150)==SUMMON_TYPE_XYZ+0x7150 end)
	c:RegisterEffect(e2)
	--cannot Grave (Do Not Remove)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE)
	ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	ge1:SetTargetRange(LOCATION_ONFIELD+LOCATION_OVERLAY,0)
	ge1:SetTarget(function(e,c) return c==e:GetHandler() end)
	ge1:SetValue(LOCATION_REMOVED)
	Duel.RegisterEffect(ge1,0)
end
function c101010429.spfilter(c,v,y,z)
	local atk=c:GetAttack()
	return c:GetLevel()==v and atk>=y and atk<=z and c:IsAbleToRemoveAsCost()
end
function c101010429.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c101010429.spfilter,tp,LOCATION_MZONE,0,1,nil,4,1050,1750)
end
function c101010429.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c101010429.spfilter,tp,LOCATION_MZONE,0,1,1,nil,4,1050,1750)
	local fg=g:Filter(Card.IsFacedown,nil)
	if fg:GetCount()>0 then Duel.ConfirmCards(1-tp,fg) end
	c:SetMaterial(g)
	Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+0x7150)
end
function c101010429.bancon(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()==PHASE_MAIN1 end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
end
function c101010429.atkfilter(c,atk)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c101010429.bantg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(1-tp) and c101010429.atkfilter(chkc,c:GetAttack()) end
	if chk==0 then return Duel.IsExistingTarget(c101010429.atkfilter,tp,0,LOCATION_REMOVED,1,nil,c:GetAttack()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101010429.atkfilter,tp,0,LOCATION_REMOVED,1,1,nil,c:GetAttack())
	local atk=g:GetFirst():GetBaseAttack()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
	local m=_G["c"..g:GetFirst():GetCode()]
	if not m or not m.spatial then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	end
end
function c101010429.banop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local m=_G["c"..tc:GetCode()]
	if tc:IsRelateToEffect(e) and Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)~=0 and (not m or not m.spatial) then
		Duel.BreakEffect()
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end

