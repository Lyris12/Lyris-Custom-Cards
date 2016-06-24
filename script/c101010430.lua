--機光襲雷竜－ビッグバン
local id,ref=GIR()
function ref.initial_effect(c)
	--self-destruct
	local ae1=Effect.CreateEffect(c)
	ae1:SetCategory(CATEGORY_DESTROY)
	ae1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetCode(EVENT_ATTACK_ANNOUNCE)
	ae1:SetCondition(ref.descon)
	ae1:SetOperation(ref.desop)
	c:RegisterEffect(ae1)
	--banish
	local ae3=Effect.CreateEffect(c)
	ae3:SetDescription(aux.Stringid(101010103,0))
	ae3:SetCategory(CATEGORY_REMOVE)
	ae3:SetType(EFFECT_TYPE_QUICK_O)
	ae3:SetCode(EVENT_FREE_CHAIN)
	ae3:SetRange(LOCATION_MZONE)
	ae3:SetCountLimit(1,101010103)
	ae3:SetCondition(ref.con)
	ae3:SetCost(ref.nktg)
	ae3:SetTarget(ref.rmtg)
	ae3:SetOperation(ref.rmop)
	c:RegisterEffect(ae3)
	--return
	local ae5=Effect.CreateEffect(c)
	ae5:SetDescription(aux.Stringid(101010103,1))
	ae5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	ae5:SetType(EFFECT_TYPE_QUICK_O)
	ae5:SetCode(EVENT_FREE_CHAIN)
	ae5:SetRange(LOCATION_MZONE)
	ae5:SetCountLimit(1,101010103)
	ae5:SetCondition(ref.con)
	ae5:SetCost(ref.cost)
	ae5:SetTarget(ref.rttg)
	ae5:SetOperation(ref.rtop)
	c:RegisterEffect(ae5)
	--special summon (Do Not Remove)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1)
	e1:SetCondition(ref.spcon)
	e1:SetOperation(ref.spop)
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
function ref.spfilter(c,v,y,z)
	local atk=c:GetAttack()
	local lv=c:GetLevel()
	return c:IsSetCard(0x167) and c:GetLevel()==v and atk>=y and atk<=z and c:IsAbleToRemoveAsCost()
end
function ref.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(ref.spfilter,tp,LOCATION_MZONE,0,1,nil,4,1800,2200)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(ref.spfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc1=g:Select(tp,1,1,nil)
	c:SetMaterial(tc1)
	local fg=tc1:Filter(Card.IsFacedown,nil)
	if fg:GetCount()>0 then Duel.ConfirmCards(1-tp,fg) end
	Duel.Remove(tc1,POS_FACEUP,REASON_MATERIAL+0x7150)
end
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function ref.dfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x167) and c:IsAbleToRemoveAsCost()
end
function ref.nktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(ref.dfilter,tp,LOCATION_GRAVE,0,4,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,ref.dfilter,tp,LOCATION_GRAVE,0,4,4,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function ref.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return c:IsAbleToRemove() and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function ref.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFirstTarget()
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 and g:IsRelateToEffect(e) then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(ref.dfilter,tp,LOCATION_GRAVE,0,5,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,ref.dfilter,tp,LOCATION_GRAVE,0,5,8,nil)
	e:SetLabel(g:GetCount())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function ref.cfilter(c)
	return not (c:IsSetCard(0x167) and c:IsType(TYPE_SPELL+TYPE_TRAP))
end
function ref.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	local g=Duel.GetMatchingGroup(ref.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	if e:GetLabel()==8 then
		local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end
end
function ref.rtop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(ref.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	if e:GetLabel()==8 then
		local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function ref.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function ref.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
