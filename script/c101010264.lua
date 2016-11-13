--created & coded by Lyris
--カオス・クローク
function c101010264.initial_effect(c)
--equip(Negate)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c101010264.condition)
	e0:SetTarget(c101010264.target)
	e0:SetOperation(c101010264.activate)
	c:RegisterEffect(e0)
	--Once per turn, you can either: Target 1 LIGHT or DARK monster you control; equip this card to that target, 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101010264,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c101010264.eqtg)
	e1:SetOperation(c101010264.eqop)
	c:RegisterEffect(e1)
	--OR: Unequip this card and Special Summon it in face-up Attack Position.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010264,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c101010264.uncon)
	e2:SetTarget(c101010264.sptg)
	e2:SetOperation(c101010264.spop)
	c:RegisterEffect(e2)
	--While equipped to a monster, LIGHT and DARK monsters you control are unaffected by your opponent's Counter Traps.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c101010264.uncon)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,0x30))
	e3:SetValue(c101010264.efilter)
	c:RegisterEffect(e3)
	--While face-up on the field, this card is also LIGHT-Attribute.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetTarget(c101010264.atcon)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_ADD_ATTRIBUTE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e4)
	--destroy sub
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e5:SetCondition(c101010264.uncon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--eqlimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_EQUIP_LIMIT)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetValue(c101010264.eqlimit)
	c:RegisterEffect(e6)
end
function c101010264.atcon(e,c)
	return c==e:GetHandler()
end
function c101010264.eqlimit(e,c)
	return c:IsAttribute(0x30)
end
function c101010264.uncon(e)
	return e:GetHandler():IsStatus(STATUS_UNION)
end
function c101010264.filter(c)
	return c:IsAttribute(0x30) and c:IsFaceup() and c:IsDestructable()
end
function c101010264.filter2(c)
	return c:IsAttribute(0x30) and c:IsFaceup() and c:GetUnionCount()==0
end
function c101010264.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_DISABLE_SUMMON)
end
function c101010264.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(101010264)==0
	and Duel.IsExistingMatchingCard(c101010264.filter,tp,LOCATION_MZONE,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(101010264,2)) then
		Duel.Hint(HINT_CARD,tp,101010264)
		e:GetHandler():RegisterFlagEffect(101010264,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
		else return false
	end
end
function c101010264.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
		Duel.SendtoGrave(e:GetHandler(),REASON_COST) return
	end
	local g=Duel.SelectMatchingCard(tp,c101010264.filter2,tp,LOCATION_MZONE,0,1,1,nil)
	if not Duel.Equip(tp,e:GetHandler(),g:GetFirst(),true) then return end
	e:GetHandler():SetStatus(STATUS_UNION,true)
	Duel.ChangeChainOperation(ev,c101010264.repop)
end
function c101010264.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil):RandomSelect(tp,1)
	Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
end
function c101010264.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101010264.filter2(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(101010264)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	and Duel.IsExistingTarget(c101010264.filter2,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c101010264.filter2,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(101010264,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c101010264.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not c101010264.filter2(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	c:SetStatus(STATUS_UNION,true)
end
function c101010264.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(101010264)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(101010264,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c101010264.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_ATTACK)
	end
end
function c101010264.efilter(e,tp,re,r,rp,te)
	return te:IsActiveType(TYPE_COUNTER) and rp~=tp and te:GetHandler()~=e:GetHandler()
end
